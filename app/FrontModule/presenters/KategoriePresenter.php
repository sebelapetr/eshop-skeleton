<?php

namespace Skeleton\FrontModule\Presenters;

use Skeleton\FrontModule\Forms\IAddProductFormFactory;
use Skeleton\FrontModule\Forms\INewQuoteFormFactory;
use Skeleton\Model\Category;
use Skeleton\Model\CategoryParent;
use Skeleton\Model\Orm;
use Nette\Utils\DateTime;
use Nette\Utils\Paginator;
use Tracy\Debugger;
use LikeFilterFunction;

class KategoriePresenter extends BasePresenter{

    /** @var int */
    public $limit;

    /** @var array  */
    public $pages = [];

    /** @var int */
    public $pagesNumber;

    /** @var  int */
    public $productsNumber;

    /** @var array */
    public $categories = [];

    /** @var int */
    public $currentCategoryId;

    /** @var array */
    public $productCategories = [];

    /** @var array */
    public $parentCategories = [];

    /** @var array  */
    public $actualCategoryChilds = [];

    /** @var int */
    public $lastPage;

    /** @var int */
    public $currentProductId;

    /**
     * @var INewQuoteFormFactory
     */
    public $newQuoteFormFactory;

    /**
     * @var IAddProductFormFactory  */
    public $addProductFormFactory;

    public function __construct(Orm $orm, INewQuoteFormFactory $newQuoteFormFactory, IAddProductFormFactory $addProductFormFactory)
    {
        parent::__construct($orm);
        $this->newQuoteFormFactory = $newQuoteFormFactory;
        $this->addProductFormFactory = $addProductFormFactory;
    }

    public function renderDefault($id, $page=1, $orderBy = null, $direction = null)
    {
        /* -NASTAVENÍ PROMĚNNÝCH- */
        $this->currentCategoryId = $id; /* -AKTUÁLNÍ KATEGORIE- */
        $this->limit = 2; /* -LIMIT PRODUKTŮ- */
        $offset = $page>0?($page-1)*$this->limit:$page; /* -OFFSET PRODUKTŮ- */
        /* ---------------------- */

        $category = $this->orm->categories->getById($id);

        $this->getTemplate()->actualId = $this->currentCategoryId;

        $this->getTemplate()->setFile(__DIR__ . "/../templates/Kategorie/default.latte");

        $this->getCategoryChilds($category);

        $categoryChilds = $this->orm->categories->findById($this->actualCategoryChilds);

        $this->getTemplate()->category = $category;


        $this->actualCategoryChilds[] = intval($this->currentCategoryId);

        $products = $this->orm->products->findBy(['category'=>$this->actualCategoryChilds, 'active' => TRUE])->limitBy($this->limit, $offset);

        $this->getTemplate()->products = $products;

        $this->lastPage = ceil($this->orm->products->findBy(['category'=>$this->categories])->countStored()/$this->limit); /* -- */


        $this->getTemplate()->actualPage = $page;
        $this->getTemplate()->pages = $this->getPages($page, $products->countStored());
        $this->getTemplate()->lastPage = ceil($products->countStored()/15);
        $session = $this->getSession()->getSection('products');
    }

    public function handleAddProductToCart($id, $currentCategory){
        $product = $this->orm->products->getById($id);
        //$array = ['id'=>$id, 'productName'=>$product->productName,'catalogPriceVat'=>$product->catalogPriceVat,'quantity'=>1, 'photo'=>$product->image];
        $productsSession = $this->getSession()->getSection('products');
        $productsSession->$id = array();
        $productsSession->$id['id'] = $id;
        $productsSession->$id['productName'] = $product->productName;
        $productsSession->$id['catalogPriceVat'] = $product->catalogPriceVat;
        $productsSession->$id['quantity'] = 1;
        $productsSession->$id['photo'] = $product->image;
        $this->flashMessage('Produkt byl přidán do košíku');
        $this->redirect('kategorie', $currentCategory);
    }

    public function getPages($actualPage, $count){
        $paginator = new Paginator();
        $paginator->setItemCount($count);
        $paginator->setItemsPerPage($this->limit);
        $paginator->setPage($actualPage);

        if(ceil($count/$this->limit)>5) {
            if($paginator->isLast()) $actualPage--;
            $rozdil = 4 - $actualPage;
            $actualPage <= 5 ? $actualPage = $actualPage + $rozdil + 1 : '';
            for ($i = ($actualPage - 4); $i <= ($actualPage + 1); $i++) {
                $this->pages[] = $i;
            }
        }
        else{
            for ($i = ($actualPage-($actualPage-1)); $i <= (ceil($count/$this->limit)); $i++) {
                $this->pages[] = $i;
            }
        }

        return $this->pages;
    }

    public function isProductInCart($id){
        $sessionProduct = $this->getSession()->getSection('products');
        if($sessionProduct->$id)
        {
            return true;
        }
        else{
            return false;
        }
    }

    public function getCategoryChilds(Category $category) {

        $childs = $this->orm->categoryParents->findBy(['parent' => $category]);

        if ($childs->countStored() > 0) {
            /** @var CategoryParent $child */
            foreach ($childs as $child) {
                if (!in_array($child->category->id, $this->actualCategoryChilds)) {
                    $this->actualCategoryChilds[] = $child->category->id;
                }
                $this->getCategoryChilds($child->category);
            }
        }

        return $this->actualCategoryChilds;

    }
}